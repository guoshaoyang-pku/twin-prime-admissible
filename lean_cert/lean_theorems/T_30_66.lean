import Sound
import lean_certs.cert_30_66

open CertVerify

theorem H30_gt_66 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 30) (d := 66) (c := cert_30_66) (by native_decide)
