import Sound
import lean_certs.cert_40_94

open CertVerify

theorem H40_gt_94 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 40) (d := 94) (c := cert_40_94) (by native_decide)
