import Sound
import lean_certs.cert_48_216

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_216_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 48) (d := 216) (c := cert_48_216) (by decide)
