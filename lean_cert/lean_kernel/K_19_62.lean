import Sound
import lean_certs.cert_19_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_62_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 19) (d := 62) (c := cert_19_62) (by decide)
