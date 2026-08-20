import Sound
import lean_certs.cert_40_154

open CertVerify

theorem H40_gt_154 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 40) (d := 154) (c := cert_40_154) (by native_decide)
