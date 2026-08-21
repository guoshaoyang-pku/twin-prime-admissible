import Sound
import lean_certs.cert_9_24

open CertVerify

theorem H9_gt_24 : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 9) (d := 24) (c := cert_9_24) (by native_decide)
