import Sound
import lean_certs.cert_49_234

open CertVerify

theorem H49_gt_234 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 49) (d := 234) (c := cert_49_234) (by native_decide)
