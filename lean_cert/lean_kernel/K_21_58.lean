import Sound
import lean_certs.cert_21_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_58_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 21) (d := 58) (c := cert_21_58) (by decide)
