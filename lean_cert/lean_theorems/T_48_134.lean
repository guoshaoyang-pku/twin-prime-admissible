import Sound
import lean_certs.cert_48_134

open CertVerify

theorem H48_gt_134 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 48) (d := 134) (c := cert_48_134) (by native_decide)
