import Sound
import lean_certs.cert_19_38

open CertVerify

theorem H19_gt_38 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 19) (d := 38) (c := cert_19_38) (by native_decide)
