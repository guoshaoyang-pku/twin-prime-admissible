import Sound
import lean_certs.cert_19_60

open CertVerify

theorem H19_gt_60 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 19) (d := 60) (c := cert_19_60) (by native_decide)
