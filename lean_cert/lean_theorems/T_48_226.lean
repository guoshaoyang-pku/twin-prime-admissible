import Sound
import lean_certs.cert_48_226

open CertVerify

theorem H48_gt_226 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 226 := by
  exact certValidRoot_sound (k := 48) (d := 226) (c := cert_48_226) (by native_decide)
