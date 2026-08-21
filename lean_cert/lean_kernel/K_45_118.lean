import Sound
import lean_certs.cert_45_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_118_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 45) (d := 118) (c := cert_45_118) (by decide)
