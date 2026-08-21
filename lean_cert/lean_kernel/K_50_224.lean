import Sound
import lean_certs.cert_50_224

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_224_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 50) (d := 224) (c := cert_50_224) (by decide)
