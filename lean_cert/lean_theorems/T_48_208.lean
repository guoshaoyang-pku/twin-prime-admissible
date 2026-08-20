import Sound
import lean_certs.cert_48_208

open CertVerify

theorem H48_gt_208 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 48) (d := 208) (c := cert_48_208) (by native_decide)
