import Sound
import lean_certs.cert_26_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_62_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 26) (d := 62) (c := cert_26_62) (by decide)
