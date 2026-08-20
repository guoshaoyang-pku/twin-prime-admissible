import Sound
import lean_certs.cert_48_162

open CertVerify

theorem H48_gt_162 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 48) (d := 162) (c := cert_48_162) (by native_decide)
