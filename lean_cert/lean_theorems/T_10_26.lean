import Sound
import lean_certs.cert_10_26

open CertVerify

theorem H10_gt_26 : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 10) (d := 26) (c := cert_10_26) (by native_decide)
