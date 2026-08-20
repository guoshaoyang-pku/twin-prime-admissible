import Sound
import lean_certs.cert_34_80

open CertVerify

theorem H34_gt_80 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 34) (d := 80) (c := cert_34_80) (by native_decide)
