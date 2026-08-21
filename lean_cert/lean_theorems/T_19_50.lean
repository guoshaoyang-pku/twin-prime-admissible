import Sound
import lean_certs.cert_19_50

open CertVerify

theorem H19_gt_50 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 19) (d := 50) (c := cert_19_50) (by native_decide)
