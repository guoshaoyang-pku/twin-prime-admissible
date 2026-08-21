import Sound
import lean_certs.cert_19_70

open CertVerify

theorem H19_gt_70 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 19) (d := 70) (c := cert_19_70) (by native_decide)
