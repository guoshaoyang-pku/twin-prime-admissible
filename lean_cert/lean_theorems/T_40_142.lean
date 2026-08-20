import Sound
import lean_certs.cert_40_142

open CertVerify

theorem H40_gt_142 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 40) (d := 142) (c := cert_40_142) (by native_decide)
