import Sound
import lean_certs.cert_25_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_58_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 25) (d := 58) (c := cert_25_58) (by decide)
