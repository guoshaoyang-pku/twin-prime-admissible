import Sound
import lean_certs.cert_24_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_62_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 24) (d := 62) (c := cert_24_62) (by decide)
