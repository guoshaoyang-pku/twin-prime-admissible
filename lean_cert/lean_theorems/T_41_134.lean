import Sound
import lean_certs.cert_41_134

open CertVerify

theorem H41_gt_134 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 41) (d := 134) (c := cert_41_134) (by native_decide)
