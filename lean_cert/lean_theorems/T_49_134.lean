import Sound
import lean_certs.cert_49_134

open CertVerify

theorem H49_gt_134 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 49) (d := 134) (c := cert_49_134) (by native_decide)
