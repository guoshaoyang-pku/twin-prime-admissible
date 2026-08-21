import Sound
import lean_certs.cert_18_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_58_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 18) (d := 58) (c := cert_18_58) (by decide)
