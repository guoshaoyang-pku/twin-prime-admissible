import Sound
import lean_certs.cert_36_154

open CertVerify

theorem H36_gt_154 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 36) (d := 154) (c := cert_36_154) (by native_decide)
