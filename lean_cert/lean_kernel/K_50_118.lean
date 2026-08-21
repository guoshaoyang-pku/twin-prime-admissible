import Sound
import lean_certs.cert_50_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_118_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 50) (d := 118) (c := cert_50_118) (by decide)
