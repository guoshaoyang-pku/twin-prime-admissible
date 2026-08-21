import Sound
import lean_certs.cert_19_68

open CertVerify

theorem H19_gt_68 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 19) (d := 68) (c := cert_19_68) (by native_decide)
