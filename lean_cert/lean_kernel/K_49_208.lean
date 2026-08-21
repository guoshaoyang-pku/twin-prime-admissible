import Sound
import lean_certs.cert_49_208

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_208_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 49) (d := 208) (c := cert_49_208) (by decide)
