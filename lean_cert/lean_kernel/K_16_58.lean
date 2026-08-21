import Sound
import lean_certs.cert_16_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_58_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 16) (d := 58) (c := cert_16_58) (by decide)
