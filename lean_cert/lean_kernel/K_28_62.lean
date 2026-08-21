import Sound
import lean_certs.cert_28_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_62_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 28) (d := 62) (c := cert_28_62) (by decide)
