import Sound
import lean_certs.cert_19_46

open CertVerify

theorem H19_gt_46 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 19) (d := 46) (c := cert_19_46) (by native_decide)
