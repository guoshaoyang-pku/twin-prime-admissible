import Sound
import lean_certs.cert_20_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_58_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 20) (d := 58) (c := cert_20_58) (by decide)
