import Sound
import lean_certs.cert_48_138

open CertVerify

theorem H48_gt_138 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 48) (d := 138) (c := cert_48_138) (by native_decide)
