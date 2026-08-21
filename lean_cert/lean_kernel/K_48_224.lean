import Sound
import lean_certs.cert_48_224

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_224_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 224 := by
  exact certValidRoot_sound (k := 48) (d := 224) (c := cert_48_224) (by decide)
