import Sound
import lean_certs.cert_40_162

open CertVerify

theorem H40_gt_162 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 40) (d := 162) (c := cert_40_162) (by native_decide)
