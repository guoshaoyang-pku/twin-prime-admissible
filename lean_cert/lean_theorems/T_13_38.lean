import Sound
import lean_certs.cert_13_38

open CertVerify

theorem H13_gt_38 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 13) (d := 38) (c := cert_13_38) (by native_decide)
