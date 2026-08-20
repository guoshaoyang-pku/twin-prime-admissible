import Sound
import lean_certs.cert_48_156

open CertVerify

theorem H48_gt_156 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 48) (d := 156) (c := cert_48_156) (by native_decide)
