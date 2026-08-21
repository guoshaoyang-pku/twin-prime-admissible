import Sound
import lean_certs.cert_20_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_62_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 20) (d := 62) (c := cert_20_62) (by decide)
