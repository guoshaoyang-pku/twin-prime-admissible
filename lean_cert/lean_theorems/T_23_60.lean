import Sound
import lean_certs.cert_23_60

open CertVerify

theorem H23_gt_60 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 23) (d := 60) (c := cert_23_60) (by native_decide)
