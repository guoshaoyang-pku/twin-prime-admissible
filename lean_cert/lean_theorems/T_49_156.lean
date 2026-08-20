import Sound
import lean_certs.cert_49_156

open CertVerify

theorem H49_gt_156 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 49) (d := 156) (c := cert_49_156) (by native_decide)
