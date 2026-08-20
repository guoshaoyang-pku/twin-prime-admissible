import Sound
import lean_certs.cert_30_134

open CertVerify

theorem H30_gt_134 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 30) (d := 134) (c := cert_30_134) (by native_decide)
