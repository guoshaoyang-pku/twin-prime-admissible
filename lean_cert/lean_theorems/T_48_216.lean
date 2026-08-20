import Sound
import lean_certs.cert_48_216

open CertVerify

theorem H48_gt_216 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 216 := by
  exact certValidRoot_sound (k := 48) (d := 216) (c := cert_48_216) (by native_decide)
