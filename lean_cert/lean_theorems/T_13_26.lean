import Sound
import lean_certs.cert_13_26

open CertVerify

theorem H13_gt_26 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 13) (d := 26) (c := cert_13_26) (by native_decide)
