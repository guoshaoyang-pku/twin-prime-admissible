import Sound
import lean_certs.cert_36_156

open CertVerify

theorem H36_gt_156 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 36) (d := 156) (c := cert_36_156) (by native_decide)
