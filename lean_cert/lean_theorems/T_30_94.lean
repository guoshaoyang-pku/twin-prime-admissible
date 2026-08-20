import Sound
import lean_certs.cert_30_94

open CertVerify

theorem H30_gt_94 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 30) (d := 94) (c := cert_30_94) (by native_decide)
