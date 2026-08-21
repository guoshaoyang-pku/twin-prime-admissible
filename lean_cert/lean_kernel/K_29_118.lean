import Sound
import lean_certs.cert_29_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_118_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 29) (d := 118) (c := cert_29_118) (by decide)
