import Sound
import lean_certs.cert_24_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_72_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 24) (d := 72) (c := cert_24_72) (by decide)
