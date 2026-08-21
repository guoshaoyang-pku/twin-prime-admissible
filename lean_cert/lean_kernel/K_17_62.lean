import Sound
import lean_certs.cert_17_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_62_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 17) (d := 62) (c := cert_17_62) (by decide)
