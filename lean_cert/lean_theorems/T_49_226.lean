import Sound
import lean_certs.cert_49_226

open CertVerify

theorem H49_gt_226 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 226 := by
  exact certValidRoot_sound (k := 49) (d := 226) (c := cert_49_226) (by native_decide)
