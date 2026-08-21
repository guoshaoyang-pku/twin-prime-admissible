import Sound
import lean_certs.cert_25_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_62_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 25) (d := 62) (c := cert_25_62) (by decide)
