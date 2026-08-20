import Sound
import lean_certs.cert_49_138

open CertVerify

theorem H49_gt_138 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 49) (d := 138) (c := cert_49_138) (by native_decide)
