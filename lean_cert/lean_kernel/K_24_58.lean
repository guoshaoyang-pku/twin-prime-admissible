import Sound
import lean_certs.cert_24_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_58_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 24) (d := 58) (c := cert_24_58) (by decide)
